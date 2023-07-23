#!/bin/bash
if ping -c 1 10.0.1.1 &> /dev/null; then
    echo "Gateway is available."
else
    echo "Gateway is not available."
fi
