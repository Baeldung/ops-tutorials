# Creating a new react application

npx create-react-app my-sample-app

# Installing React Router DOM for Routing

cd my-sample-app
npm install react-router-dom

# Updating the React Application

cat > src/App.js << EOF
import React from "react";
import { BrowserRouter as Router, Route, Routes, Link } from "react-router-dom";

const Home = () => <h2>Welcome to My Sample React App!</h2>;
const About = () => <h2>About This App</h2>;

function App() {
    return (
        <Router>
            <div>
                <nav>
                    <ul>
                        <li><Link to="/">Home</Link></li>
                        <li><Link to="/about">About</Link></li>
                    </ul>
                </nav>
                <Routes>
                    <Route path="/about" element={<About />} />
                    <Route path="/" element={<Home />} />
                </Routes>
            </div>
        </Router>
    );
}

export default App;
EOF

nano nano package.json

# Building the React Application

npm run build