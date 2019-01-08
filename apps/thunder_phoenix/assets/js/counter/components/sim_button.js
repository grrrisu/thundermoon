import React from "react";
import { connect } from "react-redux";
import { emit } from "../websocket";

const mapStateToProps = state => {
  return {
    label: state.running ? "Stop" : "Start"
  };
};

const mapDispatchToProps = (dispatch, ownProps) => {
  const messageKey = ownProps.running ? "stop" : "start";
  return {
    clickHandler: event => {
      emit(messageKey, {});
    }
  };
};

const buttonComponent = ({ label, clickHandler }) => {
  return (
    <div>
      <button className="btn btn-primary counter-button" onClick={clickHandler}>
        {label}
      </button>
    </div>
  );
};

module.exports = connect(
  mapStateToProps,
  mapDispatchToProps
)(buttonComponent);
