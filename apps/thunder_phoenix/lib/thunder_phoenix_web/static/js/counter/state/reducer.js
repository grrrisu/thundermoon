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
    case "UPDATE":
      let newState = { ...state };
      const key = `digit_${action.payload.digit}`;
      const value = parseInt(action.payload.value);
      newState.digits[key] = value;
      return newState;
    default:
      return state;
  }
};
