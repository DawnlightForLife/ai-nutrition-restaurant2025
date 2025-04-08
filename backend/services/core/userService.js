const User = require('../../models/core/userModel');

const userService = {
  async getUserById(userId) {
    return await User.findById(userId);
  },
  // TODO: implement additional user logic
};

module.exports = userService; 