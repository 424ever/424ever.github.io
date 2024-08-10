const yearsSince = (from) => {
  return new Date(new Date() - from).getFullYear() - 1970;
};

document.getElementById("age_span").innerHTML =
  `${yearsSince(new Date("2002-09-26"))}`;
