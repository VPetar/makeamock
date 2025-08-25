export default function InvitationExpired() {
  return (
    <div className="min-h-screen bg-gray-50 flex flex-col justify-center py-12 sm:px-6 lg:px-8">
      <div className="sm:mx-auto sm:w-full sm:max-w-md">
        <div className="bg-white py-8 px-4 shadow sm:rounded-lg sm:px-10">
          <div className="text-center">
            <div className="mx-auto flex items-center justify-center h-12 w-12 rounded-full bg-red-100">
              <svg className="h-6 w-6 text-red-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
              </svg>
            </div>

            <h2 className="mt-4 text-xl font-semibold text-gray-900">
              Invitation Expired
            </h2>

            <p className="mt-2 text-sm text-gray-600">
              This invitation has expired and is no longer valid.
            </p>

            <p className="mt-4 text-sm text-gray-500">
              Please contact the team admin to request a new invitation.
            </p>

            <div className="mt-6">
              <a
                href="/"
                className="w-full flex justify-center py-2 px-4 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-indigo-600 hover:bg-indigo-700"
              >
                Go to Homepage
              </a>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
