import React from "react";
import { connect } from "react-redux";

const mapStateToProps = state => {
  return {};
};

const mapDispatchToProps = dispatch => {
  return {
    clickHandler: event => {
      dispatch({ type: "INC_COUNTER", payload: "digit_1" });
    }
  };
};

const buttonComponent = ({ clickHandler }) => {
  return (
    <button className="btn btn-sm btn-info" onClick={clickHandler}>
      +
    </button>
  );
};

module.exports = connect(
  mapStateToProps,
  mapDispatchToProps
)(buttonComponent);
