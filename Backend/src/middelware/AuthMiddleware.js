const jwt = require('jsonwebtoken');

const authenticate = (request , response , next) =>{

    
    const token = request.header('x-auth-token');

    
    if(!token){
        response.status(500).json({message:'No Token , autherization denied'})
    }

    try{
        
        const decoded = jwt.verify(token , "alphabyte")
     
        
        request.user= decoded;
        next();
    }
    catch(error){
        response.status(500).json(error);
    }
}

module.exports = authenticate;