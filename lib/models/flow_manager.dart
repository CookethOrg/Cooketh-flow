// Class to manage the entire flow
import 'package:cookethflow/models/connection.dart';
import 'package:cookethflow/models/flow_node.dart';

class FlowManager {
  final Map<String, FlowNode> nodes = {};
  final Set<Connection> connections = {};

  // Add a new node
  void addNode(FlowNode node) {
    nodes[node.id] = node;
  }

  // Remove a node and all its connections
  void removeNode(String nodeId) {
    final node = nodes[nodeId];
    if (node != null) {
      // Remove all connections associated with this node
      connections.removeWhere((conn) =>
        conn.sourceNodeId == nodeId || conn.targetNodeId == nodeId);
      nodes.remove(nodeId);
    }
  }

  // Create a connection between two nodes
  bool connectNodes({
    required String sourceNodeId,
    required String targetNodeId,
    required ConnectionPoint sourcePoint,
    required ConnectionPoint targetPoint,
  }) {
    final sourceNode = nodes[sourceNodeId];
    final targetNode = nodes[targetNodeId];

    if (sourceNode == null || targetNode == null) return false;
    if (!sourceNode.isConnectionPointAvailable(sourcePoint)) return false;
    if (!targetNode.isConnectionPointAvailable(targetPoint)) return false;

    final connection = Connection(
      sourceNodeId: sourceNodeId,
      targetNodeId: targetNodeId,
      sourcePoint: sourcePoint,
      targetPoint: targetPoint,
    );

    connections.add(connection);
    sourceNode.addConnection(connection);
    targetNode.addConnection(connection);
    return true;
  }

  // Export the flow to JSON
  Map<String, dynamic> exportFlow() => {
    'nodes': nodes.map((id, node) => MapEntry(id, node.toJson())),
    'connections': connections.map((conn) => conn.toJson()).toList(),
  };
}