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
    case "CHANGE":
      return {
        ...state,
        digits: {
          ...state.digits,
          ...action.payload.answer
        }
      };
    case "JOINED":
      return {
        ...state,
        ...action.payload.answer
      };
    case "SIM_STARTED":
      return {
        ...state,
        running: true
      };
    case "SIM_STOPPED":
      return {
        ...state,
        running: false
      };
    default:
      return state;
  }
};
