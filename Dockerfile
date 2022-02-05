FROM amazon/aws-sam-cli-build-image-python3.8 
RUN pip3 install --upgrade pip
COPY requirements.txt .
RUN pip3 install -r /.serverless/requirements.txt
RUN yum -y install curl
RUN curl -sL https://rpm.nodesource.com/setup_10.x | bash -
RUN yum install nodejs -y
RUN npm install
RUN npm install -g serverless
RUN npm update -g serverless
RUN serverless -v