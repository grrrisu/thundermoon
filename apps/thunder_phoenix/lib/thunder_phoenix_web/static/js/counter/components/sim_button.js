import React from "react";
import { connect } from "react-redux";

const mapDispatchToProps = dispatch => {
  return {
    clickHandler: event => {
      console.log("start sim");
    }
  };
};

const buttonComponent = ({ clickHandler }) => {
  return (
    <div>
      <button className="btn btn-primary counter-button" onClick={clickHandler}>
        Start
      </button>
    </div>
  );
};

module.exports = connect(
  null,
  mapDispatchToProps
)(buttonComponent);
