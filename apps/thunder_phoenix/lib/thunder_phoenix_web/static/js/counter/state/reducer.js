const initialState = {};

module.exports = (state = initialState, action) => {
  switch (action.type) {
    case "update":
      throw "not yet implemented";
    default:
      return state;
  }
};
