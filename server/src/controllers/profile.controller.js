import profileService from "../services/profile.service.js";


const getProfileById = async (req, res) => {
    try {
        const profile = await profileService.getProfileById(req.user.id);
        if (!profile) {
            return res.status(404).json({
                success: false,
                message: "Profile not found"
            });
        }
        res.status(200).json({
            success: true,
            data: profile
        });
    } catch (error) {
        res.status(500).json({
            success: false,
            message: error.message
        });
    }
}

const updateProfile = async (req, res) => {
    try {
        const profile = await profileService.updateProfile(req.user.id, req.body);
       
        res.status(200).json({
            success: true,
            message: "User updated Succesfully!"
        });
    } catch (error) {
        res.status(400).json({
            success: false,
            message: error.message
        });
    }
}

const deleteProfile = async (req, res) => {
    try {
        const profile = await profileService.deleteProfile(req.user.id);
        res.status(200).json({
            success: true,
            message: "Profile deleted successfully"
        });
    } catch (error) {
        res.status(500).json({
            success: false,
            message: error.message
        });
    }
}

export default {
    getProfileById,
    updateProfile,
    deleteProfile
}