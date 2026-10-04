import mongoose from "mongoose";
import { MODEL } from "../constants/model.constant.js";
import { FriendRequestType } from "../constants/friendRequestType.constant.js";

const friendshipSchema = new mongoose.Schema({
  user1Id: {
    type: mongoose.Schema.Types.ObjectId,
    ref: MODEL.USER,
    required: true
  },
  user2Id: {
    type: mongoose.Schema.Types.ObjectId,
    ref: MODEL.USER,
    required: true
  },
  status: {
    type: String,
    enum: Object.values(FriendRequestType),
    default: FriendRequestType.PENDING
  }
}, { timestamps: true });

const Friendship = mongoose.model(MODEL.FRIENDSHIP, friendshipSchema);

export default Friendship;