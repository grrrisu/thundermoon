const initialState = {
  running: false,
  digits: {
    digit_1: 0,
    digit_10: 0,
    digit_100: 0
  }
};

module.exports = (state = initialState, action) => {
  switch (action.type) {
    case "INC_COUNTER":
      let newState = { ...state };
      const key = `digit_${action.payload.digit}`;
      const step = parseInt(action.payload.step);
      newState.digits[key] = state.digits[key] + step;
      return newState;
    case "update":
      throw "not yet implemented";
    default:
      return state;
  }
};
