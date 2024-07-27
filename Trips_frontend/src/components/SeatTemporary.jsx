import React from "react";

const SeatTemporary = ({ width, height }) => {
  return (
    <svg
      xmlns="http://www.w3.org/2000/svg"
      width={`${width || "90"}`}
      height={`${height || "90"}`}
      viewBox="0 0 22 22"
      fill="none"
    >
      <path
        d="M6.06569 19.9375H3.36988C2.62853 19.9375 2.02197 19.3188 2.02197 18.5625V11.6875C2.02197 10.5187 2.89811 9.625 4.04383 9.625C5.18955 9.625 6.06569 10.5187 6.06569 11.6875V19.9375Z"
        fill="#F7B201"
        stroke="#101010"
        strokeMiterlimit="10"
        strokeLinecap="round"
        strokeLinejoin="round"
      />
      <path
        d="M18.1968 19.9375H15.501V11.6875C15.501 10.5187 16.3771 9.625 17.5228 9.625C18.6686 9.625 19.5447 10.5187 19.5447 11.6875V18.5625C19.5447 19.3188 18.9381 19.9375 18.1968 19.9375Z"
        fill="#F7B201"
        stroke="#101010"
        strokeMiterlimit="10"
        strokeLinecap="round"
        strokeLinejoin="round"
      />
      <path
        d="M15.5013 13.0625H6.06592V19.9375H15.5013V13.0625Z"
        fill="#F7B201"
        stroke="#101010"
        strokeMiterlimit="10"
        strokeLinecap="round"
        strokeLinejoin="round"
      />
      <path
        d="M4.20801 9.65847V5.33359C4.20801 3.86872 5.32578 2.68286 6.70657 2.68286H14.794C16.2405 2.68286 17.3583 3.86872 17.3583 5.33359V9.65847"
        fill="#F7B201"
      />
      <path
        d="M4.20801 9.65847V5.33359C4.20801 3.86872 5.32578 2.68286 6.70657 2.68286H14.794C16.2405 2.68286 17.3583 3.86872 17.3583 5.33359V9.65847"
        stroke="#101010"
        strokeMiterlimit="10"
        strokeLinecap="round"
        strokeLinejoin="round"
      />
      <path
        d="M15.0476 12L6.95238 12V10.75L6.71429 9.74999L6 9H16L15.1717 10L15.0476 12Z"
        fill="#F7B201"
      />
    </svg>
  );
};

export default SeatTemporary;
