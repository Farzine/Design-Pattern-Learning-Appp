
<h1>Design Pattern Learning App</h1>



<p>Welcome to the <strong>Design Pattern Learning App</strong>, a platform where users can learn about various software design patterns, practice coding exercises, engage with a social feed similar to a simplified social network, and connect with fellow learners.</p>

<h2>Table of Contents</h2>
<ol>
  <li><a href="#overview">Overview</a></li>
  <li><a href="#features">Features</a></li>
  <li><a href="#architecture">Architecture</a></li>
  <li><a href="#technology-stack">Technology Stack</a></li>
  <li><a href="#backend-setup">Backend Setup</a></li>
  <li><a href="#frontend-setup">Frontend Setup</a></li>
  <li><a href="#api-endpoints">API Endpoints</a></li>
  <li><a href="#state-management">State Management</a></li>
  <li><a href="#how-to-run">How to Run</a></li>
  <li><a href="#screenshots">Video Demo</a></li>
  <li><a href="#challenges-faced">Challenges Faced</a></li>
  <li><a href="#future-improvements">Future Improvements</a></li>
  <li><a href="#license">License</a></li>
</ol>

<h2 id="overview">Overview</h2>
<p>The <strong>Design Pattern Learning App</strong> aims to help users understand and master common software design patterns through interactive learning materials, videos, practice tests with AI, and code examples. It also incorporates social features, allowing users to:</p>
<ul>
  <li>View a feed of posts from followed users.</li>
  <li>Like, comment, and engage with posts.</li>
  <li>Follow/unfollow other users.</li>
  <li>See friend suggestions and explore user profiles.</li>
</ul>

<p>Additionally, the app integrates AI-generated practice questions and code evaluations for design pattern tests, leveraging external AI APIs (such as Gemini AI).</p>

<p><strong>GitHub Repository:</strong> <a href="https://github.com/Farzine/Design-Pattern-Learning-Appp">Design Pattern Learning App</a></p>

<h2 id="features">Features</h2>
<ul>
  <li><strong>Authentication:</strong> Register, login, and manage profiles.</li>
  <li><strong>Profile Management:</strong> Update user details, follow/unfollow, track learning progress.</li>
  <li><strong>Design Patterns Module:</strong> Browse patterns, watch tutorial videos, read descriptions, and view example code.</li>
  <li><strong>Post Creation and Feed:</strong> Create posts, like, comment, and view a feed of posts (similar to Facebook).</li>
  <li><strong>Friend Suggestions:</strong> View other users you may know and navigate to their profiles.</li>
  <li><strong>Practice and Testing:</strong> Generate practice questions and take tests with AI, and  run code via code editor.</li>
</ul>

<h2 id="architecture">Architecture</h2>
<p>The project follows a layered architecture with a clear separation of concerns:</p>
<ul>
  <li><strong>Data Layer (Models and Repositories):</strong> Data models represent entities (User, Post, Comment, Like, etc.) and Repositories handle data retrieval from the API.</li>
  <li><strong>State Management (Riverpod Providers):</strong> Providers and StateNotifiers manage app state and asynchronous data fetching.</li>
  <li><strong>UI Layer (Flutter Screens and Widgets):</strong> The UI is composed of screens that rebuild based on provider states.</li>
</ul>

<p>Essentially, it's a <strong>Repository + Provider (Riverpod)</strong> architecture pattern.</p>

<h2 id="technology-stack">Technology Stack</h2>
<ul>
  <li><strong>Frontend:</strong> Flutter (Dart), Riverpod, Dio, JSON serialization.</li>
  <li><strong>Backend:</strong> Node.js &amp; Express, MongoDB with Mongoose, JWT for authentication.</li>
  <li><strong>Dev Tools:</strong> VSCode/Android Studio, Postman, GitHub.</li>
</ul>

<h2 id="backend-setup">Backend Setup</h2>
<ol>
  <li><strong>Prerequisites:</strong> Node.js, npm, and MongoDB running locally or a MongoDB Atlas URI.</li>
  <li><strong>Setup:</strong><br>
    <pre><code>cd backend
npm install
npm start
</code></pre>
    Ensure you have a <code>.env</code> or <code>config/default.json</code> with <code>jwtSecret</code> and MongoDB details.
  </li>
</ol>

<h2 id="frontend-setup">Frontend Setup</h2>
<ol>
  <li><strong>Prerequisites:</strong> Flutter SDK, Android Studio/VSCode with Flutter/Dart plugins.</li>
  <li><strong>Setup:</strong><br>
    <pre><code>cd frontend
flutter pub get
flutter run
</code></pre>
    Update API base URLs in repositories if needed.
  </li>
</ol>

<h2 id="api-endpoints">API Endpoints</h2>
<h3 id="api-endpoints" >[API documentation link](https://documenter.getpostman.com/view/32714993/2sAYBbd8cG)</h3>
<ul>
  <li><strong>Authentication:</strong>
    <ul>
      <li><code>POST /api/auth/register</code></li>
      <li><code>POST /api/auth/login</code></li>
    </ul>
  </li>
  <li><strong>User Management:</strong>
    <ul>
      <li><code>GET /api/users/:id</code></li>
      <li><code>PUT /api/users/:id</code></li>
      <li><code>GET /api/users</code></li>
      <li><code>POST /api/users/:id/follow</code></li>
      <li><code>POST /api/users/:id/unfollow</code></li>
    </ul>
  </li>
  <li><strong>Posts:</strong>
    <ul>
      <li><code>POST /api/posts</code></li>
      <li><code>GET /api/posts/feed</code></li>
      <li><code>POST /api/posts/:id/like</code></li>
      <li><code>POST /api/posts/:id/comment</code></li>
      <li><code>GET /api/posts/:id/comments</code></li>
      <li><code>GET /api/posts/:id/likes</code></li>
    </ul>
  </li>
  <li><strong>Design Patterns:</strong>
    <ul>
      <li><code>GET /api/design-patterns</code></li>
      <li><code>GET /api/design-patterns/:id</code></li>
    </ul>
  </li>
</ul>

<h2 id="state-management">State Management</h2>
<p>The app uses <strong>Riverpod</strong> for state management:
- <em>StateNotifierProviders</em> manage lists of posts, users, comments, likes.
- Asynchronous data fetching and UI updates are handled cleanly and testably.</p>

<h2 id="how-to-run">How to Run</h2>
<ol>
  <li><strong>Start backend API:</strong><br>
    <pre><code>cd backend
npm start
</code></pre>
  </li>
  <li><strong>Run the frontend app:</strong><br>
    <pre><code>cd frontend
flutter run
</code></pre>
  </li>
</ol>

<p>Use the app on your emulator or device. Register, login, and explore the feed and friend suggestions.</p>

<h2 id="screenshots">Video demo</h2>
<p>https://github.com/user-attachments/assets/df393e87-ef1b-4ace-aabc-bf9a53a61827</p>

<h2 id="challenges-faced">Challenges Faced</h2>
<p>Understanding and implementing the repository + Riverpod architecture was initially unfamiliar. Integrating the backend API with the frontend required careful attention to data models and token handling. Managing asynchronous states with Riverpod and ensuring a responsive, error-tolerant UI also took practice. Through these challenges, we improved our understanding of architecture, state management, and frontend-backend integration.</p>

<h2 id="future-improvements">Future Improvements</h2>
<ul>
  <li>Implement code execution and AI-generated practice questions fully.</li>
  <li>Add pagination, infinite scrolling for feeds.</li>
  <li>Enhance user profile page design.</li>
  <li>Add push notifications and real-time updates if needed.</li>
  <li>Add realtime communication and real-time updates if needed.</li>
</ul>

<h2 id="license">License</h2>
<p>This project is available under the <a href="LICENSE">MIT License</a>.</p>

</body>
</html>
