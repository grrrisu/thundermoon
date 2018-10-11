import React from "react";
import { connect } from "react-redux";

const mapStateToProps = (state, ownProps) => {
  return {
    label: parseInt(ownProps.step) > 0 ? "+" : "-"
  };
};

const mapDispatchToProps = (dispatch, ownProps) => {
  return {
    clickHandler: event => {
      dispatch({ type: "INC_COUNTER", payload: ownProps });
    }
  };
};

const buttonComponent = ({ label, clickHandler }) => {
  return (
    <button className="btn btn-sm btn-info" onClick={clickHandler}>
      {label}
    </button>
  );
};

module.exports = connect(
  mapStateToProps,
  mapDispatchToProps
)(buttonComponent);
