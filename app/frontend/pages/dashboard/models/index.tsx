import React, { useState, useCallback, useEffect, useMemo } from "react";
import {
  ReactFlow,
  Controls,
  MiniMap,
  Background,
  useNodesState,
  useEdgesState,
  addEdge,
  Connection,
  Node as ReactFlowNode,
  NodeTypes,
  BackgroundVariant,
} from "@xyflow/react";
import "@xyflow/react/dist/style.css";
import ContextMenu from "@/components/erd/ContextMenu.tsx";
import ModelNode from "@/components/erd/ModelNode.tsx";
import { useForm } from "@inertiajs/react";
import { dashboard_models_path } from "@/routes";
import debounce from "debounce";

interface DashboardModelsIndexProps {
  models: Model[];
  schema: Schema;
}

export interface Schema {
  edges: any[]
  nodes: SchemaNode[]
}

export interface SchemaNode {
  id: string
  data: Data
  type: string
  measured: Measured
  position: Position
}

export interface Data {
  id: string
  name: string
  fields: MockField[]
  mock_model_id: number
}

export interface MockField {
  id: string
  name: string
  type: string
  required: boolean
}

export interface Measured {
  width: number
  height: number
}

export interface Position {
  x: number
  y: number
}

interface Model {
  id: number;
  name: string;
  fields: Fields;
  associations: any[];
  created_at: string;
  updated_at: string;
  team_id: number;
}

interface Fields {
  age: Field;
  bio: Field;
  name: Field;
  email: Field;
  active: Field;
}

interface Field {
  type: string;
  required: boolean;
}

// Updated interfaces for ERD
interface ERDField {
  id: string;
  mock_model_id?: number;
  name: string;
  type: "string" | "text" | "integer" | "email" | "boolean";
  required: boolean;
}

interface ERDModel {
  id: string;
  name: string;
  fields: ERDField[];
  position?: { x: number; y: number };

  [key: string]: any; // Index signature for Node compatibility
}

interface ContextMenuState {
  visible: boolean;
  x: number;
  y: number;
}

export default function DashboardModelsIndex(props: DashboardModelsIndexProps) {
  const { models, schema } = props;

  const {
    post: submitForm,
    processing,
    setData,
    data: modelFormData,
  } = useForm<{model: {nodes: any[], edges: any[]}}>({ model: { nodes: [], edges: [] } });

  const [nodes, setNodes, onNodesChange] = useNodesState<ReactFlowNode>([]);
  const [edges, setEdges, onEdgesChange] = useEdgesState([]);
  const [contextMenu, setContextMenu] = useState<ContextMenuState>({
    visible: false,
    x: 0,
    y: 0,
  });
  const [nextModelId, setNextModelId] = useState(1);

  // Callback to update model data from ModelNode components
  const updateModelData = useCallback(
    (modelId: string, updatedData: Partial<ERDModel>) => {
      setNodes((nds) =>
        nds.map((node) =>
          node.id === modelId
            ? { ...node, data: { ...node.data, ...updatedData } }
            : node
        )
      );
    },
    [setNodes],
  );

  // Memoize nodeTypes to prevent React Flow from resetting on every render
  const nodeTypes: NodeTypes = useMemo(() => ({
    modelNode: (props: any) => <ModelNode {...props} onUpdateModel={updateModelData} />
  }), [updateModelData]);

  // Convert Rails models to ERD format
  const convertModelToERD = useCallback((model: Model, index: number): ReactFlowNode => {
    // Convert Rails fields object to ERD fields array
    const erdFields: ERDField[] = [];

    // Check if id field already exists in model.fields
    const hasIdField = Object.keys(model.fields).includes('id');

    // Add id field first only if it doesn't already exist
    if (!hasIdField) {
      erdFields.push({
        id: `mock-model-${model.id}-id`,
        name: "id",
        type: "integer",
        required: true,
      });
    }

    // Convert existing fields
    Object.entries(model.fields).forEach(([fieldName, field]) => {
      // Map Rails field types to ERD field types
      let erdType: ERDField["type"];

      switch (field.type.toLowerCase()) {
        case "text":
          erdType = "text";
          break;
        case "integer":
        case "bigint":
        case "decimal":
          erdType = "integer";
          break;
        case "boolean":
          erdType = "boolean";
          break;
        case "email":
          erdType = "email";
          break;
        default:
          erdType = "string";
      }

      erdFields.push({
        id: `field-${model.id}-${fieldName}`,
        name: fieldName,
        type: erdType,
        required: field.required,
      });
    });

    const erdModel: ERDModel = {
      id: `model-${model.id}`,
      mock_model_id: model.id,
      name: model.name,
      fields: erdFields,
    };

    // Find position from schema or fallback to grid layout
    let x, y;
    const schemaNode = schema?.nodes?.find(node =>
      node.data.mock_model_id === model.id ||
      node.id === `model-${model.id}`
    );

    if (schemaNode && schemaNode.position) {
      x = schemaNode.position.x;
      y = schemaNode.position.y;
    } else {
      // Fallback to grid layout if no schema position found
      const GRID_SPACING = 350;
      const COLS = 3;
      x = (index % COLS) * GRID_SPACING;
      y = Math.floor(index / COLS) * 250;
    }

    return {
      id: erdModel.id,
      type: "modelNode",
      position: { x, y },
      data: erdModel,
    };
  }, [schema]);

  // Initialize nodes from existing models
  useEffect(() => {
    if (models && models.length > 0) {
      const initialNodes = models.map((model, index) =>
        convertModelToERD(model, index),
      );
      setNodes(initialNodes);

      // Set next model ID to avoid conflicts
      const maxId = Math.max(...models.map((m) => m.id));
      setNextModelId(maxId + 1);
    }
  }, [models, convertModelToERD, setNodes]);

  const onConnect = useCallback(
    (params: Connection) => setEdges((eds) => addEdge(params, eds)),
    [setEdges],
  );

  const handleCanvasContextMenu = useCallback((event: React.MouseEvent) => {
    event.preventDefault();
    setContextMenu({ visible: true, x: event.clientX, y: event.clientY });
  }, []);

  const closeContextMenu = useCallback(() => {
    setContextMenu((prev) => ({ ...prev, visible: false }));
  }, []);

  const createNewModel = useCallback(
    (position: { x: number; y: number }) => {
      const newModel: ERDModel = {
        id: `model-${nextModelId}`,
        name: `Model ${nextModelId}`,
        fields: [
          {
            id: `field-${nextModelId}-1`,
            name: "id",
            type: "integer",
            required: true,
          },
        ],
      };

      const newNode: ReactFlowNode = {
        id: newModel.id,
        type: "modelNode",
        position,
        data: newModel,
      };

      setNodes((nds) => [...nds, newNode]);
      setNextModelId((prev) => prev + 1);
      closeContextMenu();
    },
    [nextModelId, setNodes, closeContextMenu],
  );

  useEffect(() => {
    setData("model", {
      nodes: nodes.map(node => ({
        id: node.id,
        type: node.type,
        position: node.position,
        data: node.data
      })),
      edges
    });
  }, [nodes, edges]);

  // Function to submit data to backend
  useEffect(() => {
    // debounced to avoid excessive calls
    const debouncedSubmit = debounce(() => {
      if (!processing) {
        submitForm(dashboard_models_path(), {
          preserveScroll: true,
          preserveState: true,
          only: ["models", "errors"],
        });
      }
    }, 3000);

    debouncedSubmit();

    return () => {
      debouncedSubmit.clear();
    };
  }, [modelFormData, nodes]);

  return (
    <div className="h-full w-full relative">
      <ReactFlow
        nodes={nodes}
        edges={edges}
        onNodesChange={onNodesChange}
        onEdgesChange={onEdgesChange}
        onConnect={onConnect}
        onContextMenu={handleCanvasContextMenu}
        onClick={closeContextMenu}
        nodeTypes={nodeTypes}
        fitView
        className="bg-gray-50"
        maxZoom={1}
      >
        <Controls />
        <MiniMap />
        <Background variant={BackgroundVariant.Dots} gap={12} size={1} />
      </ReactFlow>

      <ContextMenu
        visible={contextMenu.visible}
        x={contextMenu.x}
        y={contextMenu.y}
        onCreateModel={createNewModel}
        onClose={closeContextMenu}
      />
    </div>
  );
}
