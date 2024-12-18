// controllers/socialController.js
const Post = require('../models/Post');
const Comment = require('../models/Comment');
const Like = require('../models/Like');
const Follower = require('../models/Follower');

exports.createPost = async (req, res, next) => {
  try {
    const { content } = req.body;
    const post = new Post({ user_id: req.user.id, content });
    await post.save();
    res.json(post);
  } catch (err) {
    next(err);
  }
};

exports.getFeed = async (req, res, next) => {
  try {
    // Fetch the list of users the current user is following
    const following = await Follower.find({ follower_id: req.user.id }).select('following_id');
    const followingIds = following.map(f => f.following_id);

    // Include the current user's ID in the list of IDs to fetch posts
    const allUserIds = [...followingIds, req.user.id];

    // Pagination parameters
    const page = parseInt(req.query.page) || 1;
    const limit = parseInt(req.query.limit) || 10;
    const skip = (page - 1) * limit;

    // Fetch posts from both the current user and followed users
    const posts = await Post.find({ user_id: { $in: allUserIds } })
      .sort({ created_at: -1 })
      .skip(skip)
      .limit(limit)
      .populate('user_id', 'name profile_picture_url') // User's name and profile picture
      .populate({
        path: 'likes',
        populate: { path: 'user_id', select: 'name profile_picture_url' },
      })
      .populate({
        path: 'comments',
        populate: { path: 'user_id', select: 'name profile_picture_url' },
      });

    // Optionally, get the total count for frontend pagination
    const totalPosts = await Post.countDocuments({ user_id: { $in: allUserIds } });

    // Format the response to match the required structure
    const formattedPosts = posts.map(post => ({
      _id: post._id,
      user_id: {
        name: post.user_id.name,
        profile_picture_url: post.user_id.profile_picture_url,
      },
      content: post.content,
      created_at: post.created_at,
      updated_at: post.updated_at,
      likes: post.likes.map(like => ({
        _id: like._id,
        post_id: like.post_id,
        user_id: {
          name: like.user_id.name,
          profile_picture_url: like.user_id.profile_picture_url,
        },
        created_at: like.created_at,
      })),
      comments: post.comments.map(comment => ({
        _id: comment._id,
        post_id: comment.post_id,
        user_id: {
          name: comment.user_id.name,
          profile_picture_url: comment.user_id.profile_picture_url,
        },
        content: comment.content,
        created_at: comment.created_at,
        updated_at: comment.updated_at,
      })),
    }));

    res.json({
      page,
      limit,
      totalPosts,
      totalPages: Math.ceil(totalPosts / limit),
      posts: formattedPosts,
    });
  } catch (err) {
    console.error('Error fetching feed:', err.message);
    next(err);
  }
};


exports.likePost = async (req, res, next) => {
  try {
    const postId = req.params.id;
    const userId = req.user.id;

    const existingLike = await Like.findOne({ post_id: postId, user_id: userId });
    if (existingLike) {
      return res.status(400).json({ msg: 'Post already liked' });
    }

    const like = new Like({ post_id: postId, user_id: userId });
    await like.save();

    res.json({ msg: 'Post liked successfully' });
  } catch (err) {
    next(err);
  }
};

exports.commentOnPost = async (req, res, next) => {
  try {
    const postId = req.params.id;
    const { content } = req.body;
    const comment = new Comment({ post_id: postId, user_id: req.user.id, content });
    await comment.save();
    res.json(comment);
  } catch (err) {
    next(err);
  }
};


// Fetch likes for a specific post
exports.getPostLikes = async (req, res, next) => {
  try {
    const postId = req.params.id;

    // Find all likes for the post
    const likes = await Like.find({ post_id: postId }).populate('user_id', 'name profile_picture_url');

    res.json(likes);
  } catch (err) {
    next(err);
  }
};

// Fetch comments for a specific post
exports.getPostComments = async (req, res, next) => {
  try {
    const postId = req.params.id;

    // Find all comments for the post
    const comments = await Comment.find({ post_id: postId })
      .sort({ created_at: -1 }) // Sort comments by most recent
      .populate('user_id', 'name profile_picture_url');

    res.json(comments);
  } catch (err) {
    next(err);
  }
};