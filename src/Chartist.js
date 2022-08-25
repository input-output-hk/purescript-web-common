import Chartist from "chartist";
import "chartist-plugin-tooltips";
import "chartist-plugin-axistitle";

export const tooltipPlugin = Chartist.plugins.tooltip();

export const axisTitlePlugin = Chartist.plugins.ctAxisTitle;

export const intAutoScaleAxis = {
  type: Chartist.AutoScaleAxis,
  onlyInteger: true,
};

export function _updateData(chart, newData) {
  chart.update(newData);
}

// Chartist does a resize when you call update with no new data. I
// find that a bit weird and want to separate those behaviours into
// two separately-named calls in PureScript-space.
export function _resize(chart) {
  chart.update();
}

export function _barChart(element, options) {
  return new Chartist.Bar(element, {}, options, {});
}
