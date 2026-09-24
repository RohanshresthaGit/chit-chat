import { verifyToken } from '../services/jwt.services';

export const authenticate = async (req, res, next) => {
    try {
        const authHeader = req.headers.authorization;
        if (!authHeader || !authHeader.startsWith('Bearer ')) {
            return res.status(401).json({ 
                success: false,
                message: 'Invalid or expired token.' });
        }

        const token = authHeader.split(' ')[1];
        
        const payload = await verifyToken(token);

        req.user = payload;

        next();
        
    } catch (error) { 
        return res.status(401).json({ 
            success: false,
            message: 'Invalid or expired token.' });
    }
}