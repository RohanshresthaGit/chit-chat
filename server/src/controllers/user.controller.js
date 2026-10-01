import authService from "../services/auth.service.js";

const register = async (req, res) => {
    try {
        const user = await authService.registerUser(req.body);
        res.status(201).json({
            success: true,
            message: "User registered successfully",
            data: {
                id: user._id,
                fullName: user.fullName,
                email: user.email
            }
        });
    } catch (error) {
        res.status(400).json({
            success: false,
            message: error.message
        });
    }
}

const login = async (req, res) => {
    try {
        const data = await authService.loginUser(req.body);
        return res.status(200).json({
            success: true,
            data
        });

    } catch (error) {
        res.status(400).json({
            success: false,
            message: error.message
        });
    }
}

const refreshToken = async (req, res ) => {
    try{
        const { token } = req.body;
        if(!token) {
            throw new Error("Token is required");
        }
        const data = await authService.refreshToken(token);
        return res.status(200).json({
            success: true,
            data
        });
    } catch (error) {
        res.status(400).json({
            success: false,
            message: error.message
        });
    }
}

export default {
    register,
    login,
    refreshToken
}