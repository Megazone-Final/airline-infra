moved {
  from = aws_subnet.edge_public_2a
  to   = aws_subnet.primary["edge_public_2a"]
}

moved {
  from = aws_subnet.edge_public_2c
  to   = aws_subnet.primary["edge_public_2c"]
}

moved {
  from = aws_subnet.node_private_2a
  to   = aws_subnet.primary["node_private_2a"]
}

moved {
  from = aws_subnet.node_private_2c
  to   = aws_subnet.primary["node_private_2c"]
}

moved {
  from = aws_subnet.db_private_2a
  to   = aws_subnet.primary["db_private_2a"]
}

moved {
  from = aws_subnet.db_private_2c
  to   = aws_subnet.primary["db_private_2c"]
}

moved {
  from = aws_subnet.pod_private_2a
  to   = aws_subnet.pod["pod_private_2a"]
}

moved {
  from = aws_subnet.pod_private_2c
  to   = aws_subnet.pod["pod_private_2c"]
}

moved {
  from = aws_route_table_association.public_2a
  to   = aws_route_table_association.primary["edge_public_2a"]
}

moved {
  from = aws_route_table_association.public_2c
  to   = aws_route_table_association.primary["edge_public_2c"]
}

moved {
  from = aws_route_table_association.private_node_2a
  to   = aws_route_table_association.primary["node_private_2a"]
}

moved {
  from = aws_route_table_association.private_node_2c
  to   = aws_route_table_association.primary["node_private_2c"]
}

moved {
  from = aws_route_table_association.private_db_2a
  to   = aws_route_table_association.primary["db_private_2a"]
}

moved {
  from = aws_route_table_association.private_db_2c
  to   = aws_route_table_association.primary["db_private_2c"]
}

moved {
  from = aws_route_table_association.private_pod_2a
  to   = aws_route_table_association.pod["pod_private_2a"]
}

moved {
  from = aws_route_table_association.private_pod_2c
  to   = aws_route_table_association.pod["pod_private_2c"]
}
