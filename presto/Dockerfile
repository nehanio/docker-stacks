FROM trinodb/trino:354

COPY ./scripts/entrypoint.sh /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

CMD ["/usr/lib/trino/bin/run-trino"]
