import express from "express";
import followController from "../controllers/follow.controller.js";

const router = express.Router();

router.post("/", followController.followUser);
router.delete("/", followController.unfollowUser);
router.get("/requests", followController.getFollowRequests);
router.patch("/request/accept", followController.acceptFollowRequest);
router.post("/request/remove", followController.removeFollowRequest);
router.post("/request/cancel", followController.cancelFollowRequest);

export default router;