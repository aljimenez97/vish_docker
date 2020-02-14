FROM ubuntu:14.04

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y git && \
    apt-get install -y iputils-ping && \
    apt-get install -y systemd && \
    apt-get install -y net-tools && \
    apt-get install -y postgresql postgresql-contrib

USER postgres




# Create a PostgreSQL role named ``docker`` with ``docker`` as the password and
# then create a database `docker` owned by the ``docker`` role.
# Note: here we use ``&&\`` to run commands one after the other - the ``\``
#       allows the RUN command to span multiple lines.
RUN    /etc/init.d/postgresql start &&\
    psql --command "CREATE ROLE vish_dev WITH CREATEDB LOGIN PASSWORD 'yourpassword';" &&\
    psql --command "ALTER USER vish_dev WITH superuser;" &&\
    psql --command "CREATE DATABASE vish_development OWNER vish_dev;" &&\
    psql --command "CREATE DATABASE vish_test OWNER vish_dev;" &&\
    psql --command "CREATE DATABASE vish_production OWNER vish_dev;" 


# Adjust PostgreSQL configuration so that remote connections to the
# database are possible.
RUN echo "host all  all    0.0.0.0/0  md5" >> /etc/postgresql/9.3/main/pg_hba.conf

# And add ``listen_addresses`` to ``/etc/postgresql/9.3/main/postgresql.conf``
RUN echo "listen_addresses='*'" >> /etc/postgresql/9.3/main/postgresql.conf

# Expose the PostgreSQL port
EXPOSE 5432

# Add VOLUMEs to allow backup of config, logs and databases
VOLUME  ["/etc/postgresql", "/var/log/postgresql", "/var/lib/postgresql"]

# Set the default command to run when starting the container
CMD ["/usr/lib/postgresql/9.3/bin/postgres", "-D", "/var/lib/postgresql/9.3/main", "-c", "config_file=/etc/postgresql/9.3/main/postgresql.conf"]