FROM python:3.6.6-jessie

RUN pip install molecule ansible

PWD /playbook/roles/ansible-pacemaker

COPY docker-entrypoint.sh /
CMD ["/docker-entrypoint.sh"]