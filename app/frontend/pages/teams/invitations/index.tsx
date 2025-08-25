import React from 'react';
import { useForm } from '@inertiajs/react';
import { router } from '@inertiajs/react';

interface Invitation {
  id: number;
  email: string;
  status: string;
  expires_at: string;
  invited_by: {
    email: string;
  };
  created_at: string;
}

interface Team {
  id: number;
  name: string;
  guid: string;
}

interface TeamsInvitationsIndexProps {
  team: Team;
  invitations: Invitation[];
  errors?: Record<string, string[]>;
}

export default function TeamsInvitationsIndex({ team, invitations, errors }: TeamsInvitationsIndexProps) {
  const { data, setData, post, processing, reset } = useForm({
    invitation: {
      email: ''
    }
  });

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    post(`/teams/${team.guid}/teams/invitations`, {
      onSuccess: () => reset()
    });
  };

  const handleCancelInvitation = (invitationId: number) => {
    if (confirm('Are you sure you want to cancel this invitation?')) {
      router.delete(`/teams/${team.guid}/teams/invitations/${invitationId}`);
    }
  };

  const getStatusBadge = (status: string) => {
    const baseClasses = "inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium";
    switch (status) {
      case 'pending':
        return `${baseClasses} bg-yellow-100 text-yellow-800`;
      case 'accepted':
        return `${baseClasses} bg-green-100 text-green-800`;
      case 'declined':
        return `${baseClasses} bg-red-100 text-red-800`;
      default:
        return `${baseClasses} bg-gray-100 text-gray-800`;
    }
  };

  return (
    <div className="max-w-4xl mx-auto py-8 px-4 sm:px-6 lg:px-8">
      <div className="md:flex md:items-center md:justify-between">
        <div className="flex-1 min-w-0">
          <h1 className="text-2xl font-bold leading-7 text-gray-900 sm:text-3xl sm:truncate">
            Team Invitations
          </h1>
          <p className="mt-1 text-sm text-gray-500">
            Invite new members to join {team.name}
          </p>
        </div>
      </div>

      {/* Invitation Form */}
      <div className="mt-8 bg-white shadow sm:rounded-lg">
        <div className="px-4 py-5 sm:p-6">
          <h2 className="text-lg font-medium text-gray-900 mb-4">Send New Invitation</h2>
          <form onSubmit={handleSubmit} className="space-y-4">
            <div>
              <label htmlFor="invitation_email" className="block text-sm font-medium text-gray-700">
                Email Address
              </label>
              <div className="mt-1 flex rounded-md shadow-sm">
                <input
                  type="email"
                  id="invitation_email"
                  name="invitation[email]"
                  value={data.invitation.email}
                  onChange={(e) => setData('invitation', { ...data.invitation, email: e.target.value })}
                  className="flex-1 min-w-0 block w-full px-3 py-2 rounded-md border-gray-300 focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"
                  placeholder="colleague@example.com"
                  required
                />
                <button
                  type="submit"
                  disabled={processing}
                  className="ml-3 inline-flex justify-center py-2 px-4 border border-transparent shadow-sm text-sm font-medium rounded-md text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 disabled:opacity-50"
                >
                  {processing ? 'Sending...' : 'Send Invitation'}
                </button>
              </div>
              {errors?.email && (
                <p className="mt-2 text-sm text-red-600">{errors.email[0]}</p>
              )}
            </div>
          </form>
        </div>
      </div>

      {/* Invitations List */}
      <div className="mt-8 bg-white shadow overflow-hidden sm:rounded-md">
        <div className="px-4 py-5 sm:px-6">
          <h2 className="text-lg font-medium text-gray-900">Sent Invitations</h2>
          <p className="mt-1 text-sm text-gray-500">
            Manage invitations you've sent to potential team members
          </p>
        </div>
        {invitations.length === 0 ? (
          <div className="px-4 py-12 text-center">
            <p className="text-gray-500">No invitations sent yet.</p>
          </div>
        ) : (
          <ul className="divide-y divide-gray-200">
            {invitations.map((invitation) => (
              <li key={invitation.id} className="px-4 py-4 sm:px-6">
                <div className="flex items-center justify-between">
                  <div className="flex items-center">
                    <div className="flex-shrink-0">
                      <div className="w-8 h-8 bg-gray-300 rounded-full flex items-center justify-center">
                        <span className="text-sm font-medium text-gray-700">
                          {invitation.email.charAt(0).toUpperCase()}
                        </span>
                      </div>
                    </div>
                    <div className="ml-4">
                      <div className="flex items-center">
                        <p className="text-sm font-medium text-gray-900">{invitation.email}</p>
                        <span className={`ml-2 ${getStatusBadge(invitation.status)}`}>
                          {invitation.status}
                        </span>
                      </div>
                      <p className="text-sm text-gray-500">
                        Invited by {invitation.invited_by.email} • {new Date(invitation.created_at).toLocaleDateString()}
                      </p>
                      {invitation.status === 'pending' && (
                        <p className="text-xs text-gray-400">
                          Expires: {new Date(invitation.expires_at).toLocaleDateString()}
                        </p>
                      )}
                    </div>
                  </div>
                  {invitation.status === 'pending' && (
                    <button
                      onClick={() => handleCancelInvitation(invitation.id)}
                      className="text-red-600 hover:text-red-900 text-sm font-medium"
                    >
                      Cancel
                    </button>
                  )}
                </div>
              </li>
            ))}
          </ul>
        )}
      </div>
    </div>
  );
}
