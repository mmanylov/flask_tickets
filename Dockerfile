# pull official base image
FROM python:3.8.3-alpine
# Prevents Python from writing pyc files to disc (equivalent to python -B option)
ENV PYTHONDONTWRITEBYTECODE 1
# Prevents Python from buffering stdout and stderr (equivalent to python -u option)
ENV PYTHONUNBUFFERED 1
# install psycopg2 dependencies
RUN apk update
RUN apk add --no-cache --virtual .build-deps postgresql-dev gcc python3-dev musl-dev build-base
RUN pip install cython
# set work directory
WORKDIR /usr/src/app
# install dependencies
COPY ./requirements.txt .
RUN pip install --upgrade pip
RUN pip install -r requirements.txt
RUN apk del .build-deps gcc musl-dev
# copy project
COPY . .
# run entrypoint.sh
#ENTRYPOINT ["/usr/src/app/entrypoint.sh"]
CMD ["flask", "db", "upgrade"]
CMD ["flask", "run"]
