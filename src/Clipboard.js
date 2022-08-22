export function _copy(string) {
  if (navigator && navigator.clipboard) {
    navigator.clipboard.writeText(string);
  }
}
