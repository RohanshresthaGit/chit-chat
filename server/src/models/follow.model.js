import mongoose from 'mongoose';
import { MODEL } from '../constants/model.constant.js';

const followSchema = new mongoose.Schema(
    {
        followerId: {
            type: mongoose.Schema.Types.ObjectId,
            ref: MODEL.USER,
            required: true
        },
        followingId: {
            type: mongoose.Schema.Types.ObjectId,
            ref: MODEL.USER,
            required: true
        }
    },
    {
        timestamps: {
            createdAt: true,
            updatedAt: false
        }
    }
)

const Follow = mongoose.model(MODEL.FOLLOW, followSchema);

export default Follow;