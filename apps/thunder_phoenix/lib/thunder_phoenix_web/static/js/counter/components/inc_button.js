import React from "react";
import { connect } from "react-redux";
import { emit } from "../websocket";

const mapStateToProps = (state, ownProps) => {
  return {
    label: parseInt(ownProps.step) > 0 ? "+" : "-"
  };
};

const mapDispatchToProps = (dispatch, ownProps) => {
  return {
    clickHandler: event => {
      emit("inc", ownProps);
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
