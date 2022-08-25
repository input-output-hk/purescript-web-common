export function getAnimations_(element) {
  // If the browser does not implement the Web Animation API
  // we return an empty array instead of failing.
  if ("getAnimations" in element) {
    return element.getAnimations();
  } else {
    return [];
  }
}

export function getAnimationName(animation) {
  return animation.animationName;
}

export function setOnFinishHandler_(animation, cb) {
  animation.onfinish = cb;
}

export function animationFinished_(animation) {
  return animation.finished;
}
