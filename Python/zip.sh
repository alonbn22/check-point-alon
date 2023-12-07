#!/bin/bash

mkdir ./package
pip install -r requirements.txt --target ./package
cd package
zip -r ../lambda-package.zip .
cd ..
zip -g lambda-package.zip lambda_function.py