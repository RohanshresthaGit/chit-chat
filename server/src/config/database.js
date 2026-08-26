import mongoose from "mongoose";

const connectDatabase = async () => {
    try {
        await mongoose.connect(process.env.MONGO_URI);
        console.log("MongoDB connected successfully");
    } catch (e) {
        console.log("MongoDB connection failed", e);
        process.exit(1);
    }
}

export default connectDatabase;