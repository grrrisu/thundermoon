import React from "react";

import IncButton from "./inc_button";
import Digit from "./digit";

module.exports = ({ digit }) => {
  return (
    <div className="digit-container">
      <IncButton digit={digit} step="1" />
      <Digit digit={digit} />
      <IncButton digit={digit} step="-1" />
    </div>
  );
};
