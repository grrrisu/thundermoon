const initialState = {
  running: false,
  digits: {
    counter_1: 0,
    counter_10: 0,
    counter_100: 0
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
