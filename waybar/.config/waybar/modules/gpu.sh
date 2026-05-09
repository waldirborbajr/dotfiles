#!/bin/bash
GPU_UTIL=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits)
CSS_CLASS="low"

if ((GPU_UTIL > 30 && GPU_UTIL < 60)); then
  CSS_CLASS="medium"
fi

if ((GPU_UTIL > 60)); then
  CSS_CLASS="high"
fi

printf '{"text": "%s", "class": "%s"}' "${GPU_UTIL}%" "$CSS_CLASS"
