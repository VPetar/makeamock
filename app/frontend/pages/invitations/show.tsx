import { router } from '@inertiajs/react';

interface Invitation {
  id: number;
  email: string;
  status: string;
  expires_at: string;
  team: {
    name: string;
    guid: string;
  };
  invited_by: {
    email: string;
  };
  token: string;
}

interface InvitationShowProps {
  invitation: Invitation;
  current_user?: {
    email: string;
  };
}

export default function InvitationShow({ invitation, current_user }: InvitationShowProps) {
  const handleAccept = () => {
    router.patch(`/invitations/${invitation.token}/accept`);
  };

  const handleDecline = () => {
    if (confirm('Are you sure you want to decline this invitation?')) {
      router.patch(`/invitations/${invitation.token}/decline`);
    }
  };

  return (
    <div className="min-h-screen bg-gray-50 flex flex-col justify-center py-12 sm:px-6 lg:px-8">
      <div className="sm:mx-auto sm:w-full sm:max-w-md">
        <div className="text-center">
          <h1 className="text-3xl font-extrabold text-gray-900">
            Team Invitation
          </h1>
          <p className="mt-2 text-sm text-gray-600">
            You've been invited to join a team
          </p>
        </div>
      </div>

      <div className="mt-8 sm:mx-auto sm:w-full sm:max-w-md">
        <div className="bg-white py-8 px-4 shadow sm:rounded-lg sm:px-10">
          <div className="text-center">
            <div className="mx-auto flex items-center justify-center h-12 w-12 rounded-full bg-indigo-100">
              <svg className="h-6 w-6 text-indigo-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z" />
              </svg>
            </div>

            <h2 className="mt-4 text-xl font-semibold text-gray-900">
              Join "{invitation.team.name}"
            </h2>

            <p className="mt-2 text-sm text-gray-600">
              {invitation.invited_by.email} has invited you to join their team.
            </p>

            {current_user && current_user.email === invitation.email ? (
              <div className="mt-6 space-y-3">
                <button
                  onClick={handleAccept}
                  className="w-full flex justify-center py-2 px-4 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
                >
                  Accept Invitation
                </button>

                <button
                  onClick={handleDecline}
                  className="w-full flex justify-center py-2 px-4 border border-gray-300 rounded-md shadow-sm text-sm font-medium text-gray-700 bg-white hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
                >
                  Decline
                </button>
              </div>
            ) : (
              <div className="mt-6">
                <p className="text-sm text-red-600 mb-4">
                  {current_user
                    ? `This invitation is for ${invitation.email}, but you're signed in as ${current_user.email}.`
                    : 'Please sign in to accept this invitation.'
                  }
                </p>
                <a
                  href="/users/sign_in"
                  className="w-full flex justify-center py-2 px-4 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
                >
                  Sign In
                </a>
              </div>
            )}

            <div className="mt-6 pt-6 border-t border-gray-200">
              <p className="text-xs text-gray-500">
                This invitation expires on {new Date(invitation.expires_at).toLocaleDateString()}
              </p>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
