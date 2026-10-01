import express from "express";
import authController from "../controllers/user.controller.js";

const router = express.Router();
router.post("/register", authController.register);
router.post("/login", authController.login);
router.post("/refresh-token", authController.refreshToken);

export default router;