import * as followService from '../services/follow.service.js';

const followUser = async (req, res) => {
    const { followingId } = req.body;
    if (!followingId) {
        return res.status(400).json({
            success: false,
            message: "Following ID is required"
        });
    }
    const result = await followService.followUser(req.user.id, followingId);
    return res.status(200).json({
        success: true,
        message: "Friend request sent successfully"
    });
}

const unfollowUser = async (req, res) => {
    const { followingId } = req.body;
    if (!followingId) {
        return res.status(400).json({
            success: false,
            message: "Following ID is required"
        });
    }
    const result = await followService.unfollowUser(req.user.id, followingId);
    return res.status(200).json({
        success: true,
        message: "You are not friends anymore"
    });
}

const acceptFollowRequest = async (req, res) => {
    const { senderId } = req.body;
    if (!senderId) {
        return res.status(400).json({
            success: false,
            message: "senderId ID is required"
        });
    }
    const result = await followService.acceptFollowRequest(senderId, req.user.id);
    return res.status(200).json({
        success: true,
        message: "You are now friends"
    });
}

const removeFollowRequest = async (req, res) => {
    const { senderId } = req.body;
    if (!senderId) {
        return res.status(400).json({
            success: false,
            message: "senderId ID is required"
        });
    }
    const result = await followService.removeFollowRequest(senderId, req.user.id);
    return res.status(200).json({
        success: true,
        message: "Follow request removed successfully"
    });
}

const cancelFollowRequest = async (req, res) => {
    const { receiverId } = req.body;
    if (!receiverId) {
        return res.status(400).json({
            success: false,
            message: "receiverId ID is required"
        });
    }
    const result = await followService.cancelFollowRequest(req.user.id, receiverId);
    return res.status(200).json({
        success: true,
        message: "Follow request canceled successfully"
    });
}

const getFollowRequests = async (req, res) => {
    const { page, limit } = req.body;
    const id = req.user.id;

    const result = await followService.getFollowRequests(id, page, limit);
    return res.status(200).json({
        success: true,
        data: result
    });
}

export default {
    followUser,
    unfollowUser,
    acceptFollowRequest,
    removeFollowRequest,
    cancelFollowRequest,
    getFollowRequests
}