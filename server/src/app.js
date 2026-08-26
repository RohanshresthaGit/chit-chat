import express from "express";
import cors from "cors";
import helmet from "helmet";
import morgon from "morgan";

import authRoutes from "./routes/auth.routes.js";
import errorMiddleware from "./middleware/error.middleware.js";

const app = express();

app.use(helmet());
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
if(process.env.NODE_EVN === "development") {
    app.use(morgon("dev"));
}

app.get("/api/v1/health", (req, res) => {
    res.status(200).json({
        success: true,
        message: "Server is running"
    });
});

app.use("/api/v1/auth", authRoutes);

app.use(errorMiddleware);

export default app;