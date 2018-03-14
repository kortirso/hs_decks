import "./collection.css";

const $ = require("jquery");

$(document).foundation();

$("#cards_collection .costs label").click(function(e) {
  e.preventDefault();
  if ($(this).hasClass("none")) {
    $(this)
      .removeClass("none")
      .addClass("single");
    $(this)
      .closest("div")
      .children("input")
      .val(1)
      .attr("checked", true);
  } else if ($(this).hasClass("single")) {
    if (
      $(this)
        .closest(".card")
        .hasClass("Legendary")
    ) {
      $(this)
        .removeClass("single")
        .addClass("none");
      $(this)
        .closest("div")
        .children("input")
        .val(0);
    } else {
      $(this)
        .removeClass("single")
        .addClass("double");
      $(this)
        .closest("div")
        .children("input")
        .val(2);
    }
  } else {
    $(this)
      .removeClass("double")
      .addClass("none");
    $(this)
      .closest("div")
      .children("input")
      .val(0);
  }
});

$("#free_existed").on("click", function(e) {
  e.preventDefault();
  $(".card.Free input")
    .val(2)
    .prop("checked", true);
  $(".card.Free label")
    .removeClass("none")
    .removeClass("single")
    .removeClass("double")
    .addClass("double");
});

$(".class_existed").on("click", function(e) {
  e.preventDefault();
  name = $(this)
    .attr("class")
    .split(" ")
    .pop();
  $("." + name + " input")
    .val(2)
    .prop("checked", true);
  $("." + name + " label")
    .removeClass("none")
    .removeClass("single")
    .removeClass("double")
    .addClass("double");
  $("." + name + " .Legendary input")
    .val(1)
    .prop("checked", true);
  $("." + name + " .Legendary label")
    .removeClass("none")
    .removeClass("single")
    .removeClass("double")
    .addClass("single");
});

$(".class_unexisted").on("click", function(e) {
  e.preventDefault();
  name = $(this)
    .attr("class")
    .split(" ")
    .pop();
  $("." + name + " input").val(0);
  $("." + name + " label")
    .removeClass("none")
    .removeClass("single")
    .removeClass("double")
    .addClass("none");
});

$("#collection").on("change", function() {
  let collection = this.value;
  if (collection == "") $(".card").show();
  else {
    $(".card").hide();
    console.log(
      collection
        .split(" ")
        .join("_")
        .split("'")
        .join("")
    );
    $(
      ".card." +
        collection
          .split(" ")
          .join("_")
          .split("'")
          .join("")
    ).show();
  }
});

$("#mana_cost").on("change", function() {
  let mana = this.value;
  if (mana == "") $(".costs").show();
  else {
    $(".costs").hide();
    $(".cost_" + mana).show();
  }
});
