import { useCallback, useEffect, useRef } from 'react';
import { Database } from 'lucide-react';

interface ContextMenuProps {
  visible: boolean;
  x: number;
  y: number;
  onCreateModel: (position: { x: number; y: number }) => void;
  onClose: () => void;
}

export default function ContextMenu({ visible, x, y, onCreateModel, onClose }: ContextMenuProps) {
  const menuRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    const handleClickOutside = (event: MouseEvent) => {
      if (menuRef.current && !menuRef.current.contains(event.target as Node)) {
        onClose();
      }
    };

    const handleEscape = (event: KeyboardEvent) => {
      if (event.key === 'Escape') {
        onClose();
      }
    };

    if (visible) {
      document.addEventListener('mousedown', handleClickOutside);
      document.addEventListener('keydown', handleEscape);
    }

    return () => {
      document.removeEventListener('mousedown', handleClickOutside);
      document.removeEventListener('keydown', handleEscape);
    };
  }, [visible, onClose]);

  const handleCreateModel = useCallback(() => {
    // Convert screen coordinates to flow coordinates
    // For now, we'll use a simple offset from the click position
    const flowPosition = {
      x: x - 200, // Offset to center the new model near the click
      y: y - 100,
    };
    onCreateModel(flowPosition);
  }, [x, y, onCreateModel]);

  if (!visible) return null;

  return (
    <div
      ref={menuRef}
      className="fixed z-50 bg-white border border-gray-200 rounded-lg shadow-lg py-2 min-w-[180px]"
      style={{
        left: x,
        top: y,
      }}
    >
      <button
        onClick={handleCreateModel}
        className="w-full px-4 py-2 text-left text-sm text-gray-700 hover:bg-gray-100 flex items-center gap-3 transition-colors"
      >
        <Database size={16} className="text-blue-500" />
        Create New Model
      </button>

      <div className="border-t border-gray-100 my-1"></div>

      <div className="px-4 py-2 text-xs text-gray-500">
        Right-click to create models and build your ERD
      </div>
    </div>
  );
}
