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
      return {
        ...state,
        digits: {
          ...state.digits,
          digit_1: state.digits.digit_1 + 1
        }
      };
    case "update":
      throw "not yet implemented";
    default:
      return state;
  }
};
