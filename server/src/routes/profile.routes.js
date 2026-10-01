import express from "express";
import profileController from "../controllers/profile.controller.js";

const router = express.Router();

router.get("/", profileController.getProfileById);
router.put("/", profileController.updateProfile);
router.delete("/", profileController.deleteProfile);

export default router;