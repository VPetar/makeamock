import { useState, useCallback } from 'react';
import { Handle, Position, NodeProps } from '@xyflow/react';
import { Plus, X, Edit2, Check } from 'lucide-react';

interface ERDField {
  id: string;
  name: string;
  type: 'string' | 'text' | 'integer' | 'email' | 'boolean';
  required: boolean;
}

interface ERDModel {
  id: string;
  name: string;
  fields: ERDField[];
  [key: string]: any; // Index signature for Node compatibility
}

interface ModelNodeProps extends NodeProps {
  data: ERDModel;
  onUpdateModel?: (modelId: string, updatedData: Partial<ERDModel>) => void;
}

const fieldTypes = ['string', 'text', 'integer', 'email', 'boolean'] as const;

export default function ModelNode({ data, id, onUpdateModel }: ModelNodeProps) {
  const [isEditingName, setIsEditingName] = useState(false);
  const [modelName, setModelName] = useState(data.name);
  const [editingFieldId, setEditingFieldId] = useState<string | null>(null);
  const [fields, setFields] = useState<ERDField[]>(data.fields);

  const handleNameEdit = useCallback(() => {
    setIsEditingName(true);
  }, []);

  const handleNameSave = useCallback(() => {
    setIsEditingName(false);
    // Update parent component with new model name
    if (onUpdateModel && id) {
      onUpdateModel(id, { name: modelName });
    }
  }, [modelName, onUpdateModel, id]);

  const addField = useCallback(() => {
    const newField: ERDField = {
      id: `field-${Date.now()}`,
      name: 'new_field',
      type: 'string',
      required: false,
    };
    const updatedFields = [...fields, newField];
    setFields(updatedFields);
    setEditingFieldId(newField.id);

    // Update parent component with new fields
    if (onUpdateModel && id) {
      onUpdateModel(id, { fields: updatedFields });
    }
  }, [fields, onUpdateModel, id]);

  const removeField = useCallback((fieldId: string) => {
    const updatedFields = fields.filter(field => {
      // Don't allow removing the id field
      if (field.name === 'id') {
        return true; // Keep the field
      }
      return field.id !== fieldId; // Remove other fields normally
    });
    setFields(updatedFields);

    // Update parent component with updated fields
    if (onUpdateModel && id) {
      onUpdateModel(id, { fields: updatedFields });
    }
  }, [fields, onUpdateModel, id]);

  const updateField = useCallback((fieldId: string, updates: Partial<ERDField>) => {
    const updatedFields = fields.map(field =>
      field.id === fieldId ? { ...field, ...updates } : field
    );
    setFields(updatedFields);

    // Update parent component with updated fields
    if (onUpdateModel && id) {
      onUpdateModel(id, { fields: updatedFields });
    }
  }, [fields, onUpdateModel, id]);

  const getFieldTypeColor = (type: string) => {
    const colors = {
      string: 'bg-blue-100 text-blue-800',
      text: 'bg-purple-100 text-purple-800',
      integer: 'bg-green-100 text-green-800',
      email: 'bg-orange-100 text-orange-800',
      boolean: 'bg-gray-100 text-gray-800',
    };
    return colors[type as keyof typeof colors] || 'bg-gray-100 text-gray-800';
  };

  return (
    <div className="bg-white border-2 border-gray-300 rounded-lg shadow-lg min-w-[280px] max-w-[400px]">
      {/* Model Header */}
      <div className="bg-gray-100 border-b border-gray-300 p-3 rounded-t-lg">
        {isEditingName ? (
          <div className="flex items-center gap-2">
            <input
              type="text"
              value={modelName}
              onChange={(e) => setModelName(e.target.value)}
              className="flex-1 px-2 py-1 text-lg font-semibold bg-white border border-gray-300 rounded"
              onBlur={handleNameSave}
              onKeyDown={(e) => e.key === 'Enter' && handleNameSave()}
              autoFocus
            />
            <button onClick={handleNameSave} className="text-green-600 hover:text-green-800">
              <Check size={16} />
            </button>
          </div>
        ) : (
          <div className="flex items-center justify-between">
            <h3 className="text-lg font-semibold text-gray-800">{modelName}</h3>
            <button onClick={handleNameEdit} className="text-gray-500 hover:text-gray-700">
              <Edit2 size={16} />
            </button>
          </div>
        )}
      </div>

      {/* Fields List */}
      <div className="p-3">
        {fields.map((field) => (
          <div key={field.id} className="flex items-center gap-2 py-2 border-b border-gray-100 last:border-b-0">
            {editingFieldId === field.id ? (
              <div
                className="flex-1 grid grid-cols-4 gap-2"
                onMouseDown={(e) => e.stopPropagation()}
                onClick={(e) => e.stopPropagation()}
              >
                <input
                  type="text"
                  value={field.name}
                  onChange={(e) => updateField(field.id, { name: e.target.value })}
                  className="px-2 py-1 text-sm border border-gray-300 rounded"
                  onKeyDown={(e) => e.key === 'Enter' && setEditingFieldId(null)}
                  onMouseDown={(e) => e.stopPropagation()}
                  onClick={(e) => e.stopPropagation()}
                  autoFocus
                />
                <select
                  value={field.type}
                  onChange={(e) => updateField(field.id, { type: e.target.value as ERDField['type'] })}
                  onMouseDown={(e) => e.stopPropagation()}
                  onClick={(e) => e.stopPropagation()}
                  onFocus={(e) => e.stopPropagation()}
                  className="px-2 py-1 text-sm border border-gray-300 rounded"
                >
                  {fieldTypes.map(type => (
                    <option key={type} value={type}>{type}</option>
                  ))}
                </select>
                <label
                  className="flex items-center gap-1 text-sm"
                  onMouseDown={(e) => e.stopPropagation()}
                  onClick={(e) => e.stopPropagation()}
                >
                  <input
                    type="checkbox"
                    checked={field.required}
                    onChange={(e) => updateField(field.id, { required: e.target.checked })}
                    onMouseDown={(e) => e.stopPropagation()}
                    onClick={(e) => e.stopPropagation()}
                    className="rounded"
                  />
                  Required
                </label>
                <button
                  onClick={() => setEditingFieldId(null)}
                  onMouseDown={(e) => e.stopPropagation()}
                  className="px-2 py-1 text-sm bg-green-100 text-green-700 rounded hover:bg-green-200"
                >
                  Done
                </button>
              </div>
            ) : (
              <>
                <div className="flex-1 flex items-center gap-2">
                  <span className="font-medium text-sm">{field.name}</span>
                  <span className={`px-2 py-1 text-xs rounded ${getFieldTypeColor(field.type)}`}>
                    {field.type}
                  </span>
                  {field.required && (
                    <span className="text-red-500 text-xs">*</span>
                  )}
                </div>
                <div className="flex gap-1">
                  <button
                    onClick={(e) => {
                      e.stopPropagation();
                      setEditingFieldId(field.id);
                    }}
                    onMouseDown={(e) => e.stopPropagation()}
                    className="text-gray-400 hover:text-gray-600"
                  >
                    <Edit2 size={14} />
                  </button>
                  {field.name !== 'id' && (
                    <button
                      onClick={(e) => {
                        e.stopPropagation();
                        removeField(field.id);
                      }}
                      onMouseDown={(e) => e.stopPropagation()}
                      className="text-red-400 hover:text-red-600"
                    >
                      <X size={14} />
                    </button>
                  )}
                </div>
              </>
            )}
          </div>
        ))}

        {/* Add Field Button */}
        <button
          onClick={addField}
          className="w-full mt-3 py-2 border-2 border-dashed border-gray-300 rounded-lg text-gray-500 hover:border-blue-400 hover:text-blue-600 flex items-center justify-center gap-2 transition-colors"
        >
          <Plus size={16} />
          Add Field
        </button>
      </div>

      {/* Connection Handles */}
      <Handle
        type="target"
        position={Position.Left}
        style={{ background: '#555' }}
      />
      <Handle
        type="source"
        position={Position.Right}
        style={{ background: '#555' }}
      />
    </div>
  );
}
