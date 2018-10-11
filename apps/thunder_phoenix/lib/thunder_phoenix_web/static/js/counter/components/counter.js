import React from "react";

import IncButton from "./inc_button";
import Digit from "./digit";

console.log(Digit);

module.exports = () => {
  return (
    <div className="digit-container">
      <IncButton />
      <Digit />
      <IncButton />
    </div>
  );
};
