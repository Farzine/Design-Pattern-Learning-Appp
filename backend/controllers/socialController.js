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

    // Pagination parameters
    const page = parseInt(req.query.page) || 1;
    const limit = parseInt(req.query.limit) || 10;
    const skip = (page - 1) * limit;

    // Fetch posts with pagination, populate user details, likes, and comments
    const posts = await Post.find({ user_id: { $in: followingIds } })
      .sort({ created_at: -1 })
      .skip(skip)
      .limit(limit)
      .populate('user_id', 'name profile_picture_url')
      .populate({
        path: 'likes',
        populate: { path: 'user_id', select: 'name' },
      })
      .populate({
        path: 'comments',
        populate: { path: 'user_id', select: 'name profile_picture_url' },
      });

    // Optionally, get the total count for frontend pagination
    const totalPosts = await Post.countDocuments({ user_id: { $in: followingIds } });

    res.json({
      page,
      limit,
      totalPosts,
      totalPages: Math.ceil(totalPosts / limit),
      posts,
    });
  } catch (err) {
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
