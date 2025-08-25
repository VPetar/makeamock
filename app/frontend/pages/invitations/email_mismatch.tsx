export default function InvitationEmailMismatch() {
  return (
    <div className="min-h-screen bg-gray-50 flex flex-col justify-center py-12 sm:px-6 lg:px-8">
      <div className="sm:mx-auto sm:w-full sm:max-w-md">
        <div className="bg-white py-8 px-4 shadow sm:rounded-lg sm:px-10">
          <div className="text-center">
            <div className="mx-auto flex items-center justify-center h-12 w-12 rounded-full bg-orange-100">
              <svg className="h-6 w-6 text-orange-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-2.5L13.732 4c-.77-.833-1.964-.833-2.732 0L4.082 15.5c-.77.833.192 2.5 1.732 2.5z" />
              </svg>
            </div>

            <h2 className="mt-4 text-xl font-semibold text-gray-900">
              Email Address Mismatch
            </h2>

            <p className="mt-2 text-sm text-gray-600">
              This invitation was sent to a different email address than the one you're currently signed in with.
            </p>

            <p className="mt-4 text-sm text-gray-500">
              Please sign in with the correct email address or contact the team admin for a new invitation.
            </p>

            <div className="mt-6 space-y-3">
              <a
                href="/users/sign_out"
                className="w-full flex justify-center py-2 px-4 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-indigo-600 hover:bg-indigo-700"
              >
                Sign Out & Try Again
              </a>

              <a
                href="/"
                className="w-full flex justify-center py-2 px-4 border border-gray-300 rounded-md shadow-sm text-sm font-medium text-gray-700 bg-white hover:bg-gray-50"
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
