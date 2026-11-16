import User from "../models/user.model.js";
import Follow from "../models/follow.model.js";
import FriendRequest from "../models/friendRequest.model.js";
import { FriendRequestType } from '../constants/friendRequestType.constant.js'

const followUser = async (followerId, followingId) => {
    if (followerId === followingId) {
        throw new Error("You cannot follow yourself");
    }
    const followedUser = await User.findById(followingId);
    if (!followedUser) {
        throw new Error("User not found");
    }

    const follow = await Follow.findOne({ follower: followerId, following: followingId });
    if (follow) {
        throw new Error("You are already following this user");
    }

    const followRequest = new FriendRequest({
        sender: followerId,
        receiver: followingId,
        status: FriendRequestType.PENDING
    })
    await followRequest.save();

    return true;
}

const unfollowUser = async (followerId, followingId) => {
    if (followerId === followingId) {
        throw new Error("You cannot unfollow yourself");
    }

    const follow = await Follow.findOne({ follower: followerId, following: followingId });
    if (!follow) {
        throw new Error("You are not following this user");
    }

    const result = await Follow.deleteOne({ follower: followerId, following: followingId });
    if (result.deletedCount === 0) {
        throw new Error("Failed to unfollow the user");
    }

    return true;
}

const acceptFollowRequest = async (senderId, receiverId) => {
    const followRequest = await FriendRequest.findOne({ senderId: senderId, receiverId: receiverId, status: FriendRequestType.PENDING });
    if (!followRequest) {
        throw new Error("Follow request not found");
    }
    if (followRequest.status !== FriendRequestType.PENDING) {
        throw new Error("Follow request is not pending");
    }

    followRequest.status = FriendRequestType.ACCEPTED;
    await followRequest.save();

    const follow = new Follow({
        follower: followRequest.sender,
        following: followRequest.receiver
    });
    await follow.save();

    return true;
}

const removeFollowRequest = async (senderId, receiverId) => {
    const followRequest = await FriendRequest.findOne({ senderId: senderId, receiverId: receiverId, status: FriendRequestType.PENDING });
    if (!followRequest) {
        throw new Error("Follow request not found");
    }
    if (followRequest.status !== FriendRequestType.PENDING) {
        throw new Error("Follow request is not pending");
    }

    followRequest.status = FriendRequestType.REJECTED;
    await followRequest.save();

    return true;
}

const cancelFriendRequest = async (senderId, receiverId) => {
    const followRequest = await FriendRequest.findOne({ senderId: senderId, receiverId: receiverId, status: FriendRequestType.PENDING });
    if (!followRequest) {
        throw new Error("Follow request not found");
    }
    if (followRequest.status !== FriendRequestType.PENDING) {
        throw new Error("Follow request is not pending");
    }

    await FriendRequest.deleteOne({ _id: followRequest._id });

    return true;
}

const findFriends = async (userId, searchTerm = "", page = 1, limit = 10) => {
    page = Math.max(1, Number(page) || 1);
    limit = Math.min(50, Math.max(1, Number(limit) || 10));

    const skip = (page - 1) * limit;

    // 1. Find existing friendships
    const friendships = await Friend.find({
        $or: [
            { userId },
            { friendId: userId }
        ]
    }).populate([
        {
            path: "userId",
            select: "fullName image"
        },
        {
            path: "friendId",
            select: "fullName image"
        }
    ]);

    // 2. Extract friend IDs
    const friendIds = friendships.map(friend =>
        friend.userId._id.toString() === userId.toString()
            ? friend.friendId._id
            : friend.userId._id
    );

    // 3. Build search filter
    const filter = {
        _id: { $nin: [userId, ...friendIds] }
    };

    // Apply search only when searchTerm exists
    if (searchTerm.trim()) {
        const escapedSearch = searchTerm.replace(
            /[.*+?^${}()|[\]\\]/g,
            "\\$&"
        );

        filter.$or = [
            {
                fullName: {
                    $regex: escapedSearch,
                    $options: "i"
                }
            },
            {
                email: {
                    $regex: escapedSearch,
                    $options: "i"
                }
            }
        ];
    }

    // 4. Fetch users and count in parallel
    const [users, totalUsers] = await Promise.all([
        User.find(filter)
            .select("fullName image")
            .sort({ fullName: 1 })
            .skip(skip)
            .limit(limit)
            .lean(),

        User.countDocuments(filter)
    ]);

    // 5. Pagination
    const totalPages = Math.ceil(totalUsers / limit);

    return {
        users,
        pagination: {
            totalUsers,
            currentPage: page,
            limit,
            totalPages,
            hasNextPage: page < totalPages,
            hasPrevPage: page > 1
        }
    };
};

const getFollowersRequests = async (userId, page = 1, limit = 10) => {
    page = Math.max(1, Number(page) || 1);
    limit = Math.min(50, Math.max(1, Number(limit) || 10));
    const skip = (page - 1) * limit;

    const filter = {
        receiver: userId,
        status: FriendRequestType.PENDING
    };

    const [requests, totalRequests] = await Promise.all([
        FriendRequest.find(filter)
            .populate('sender', 'fullName email profileImage')
            .sort({ createdAt: -1 })
            .skip(skip)
            .limit(limit),
        FriendRequest.countDocuments(filter)
    ]);

    const totalPages = Math.ceil(totalRequests / limit);


    return {
        requests,
        pagination: {
            totalRequests,
            currentPage: page,
            limit,
            totalPages: totalPages,
            hasNextPage: page < totalPages,
            hasPrevPage: page > 1
        }
    };
}


export default {
    followUser,
    unfollowUser,
    acceptFollowRequest,
    removeFollowRequest,
    cancelFriendRequest,
    getFollowersRequests,
    findFriends,
}