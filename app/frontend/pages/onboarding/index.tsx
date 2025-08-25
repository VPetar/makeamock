import { useForm } from '@inertiajs/react';

interface OnboardingIndexProps {
  errors?: Record<string, string[]>;
}

export default function OnboardingIndex({ errors }: OnboardingIndexProps) {
  const { data, setData, post, processing } = useForm({
    team: {
      name: ''
    }
  });

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    post('/onboarding/create_team');
  };

  return (
    <div className="min-h-screen bg-gray-50 flex flex-col justify-center py-12 sm:px-6 lg:px-8">
      <div className="sm:mx-auto sm:w-full sm:max-w-md">
        <h1 className="mt-6 text-center text-3xl font-extrabold text-gray-900">
          Welcome! Let's create your team
        </h1>
        <p className="mt-2 text-center text-sm text-gray-600">
          To get started, you'll need to create a team. You'll be the admin of this team.
        </p>
      </div>

      <div className="mt-8 sm:mx-auto sm:w-full sm:max-w-md">
        <div className="bg-white py-8 px-4 shadow sm:rounded-lg sm:px-10">
          <form onSubmit={handleSubmit} className="space-y-6">
            <div>
              <label htmlFor="team_name" className="block text-sm font-medium text-gray-700">
                Team Name
              </label>
              <div className="mt-1">
                <input
                  id="team_name"
                  name="team[name]"
                  type="text"
                  autoComplete="organization"
                  required
                  value={data.team.name}
                  onChange={(e) => setData('team', { ...data.team, name: e.target.value })}
                  className="appearance-none block w-full px-3 py-2 border border-gray-300 rounded-md placeholder-gray-400 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"
                  placeholder="Enter your team name"
                />
              </div>
              {errors?.name && (
                <p className="mt-2 text-sm text-red-600">{errors.name[0]}</p>
              )}
            </div>

            <div>
              <button
                type="submit"
                disabled={processing}
                className="w-full flex justify-center py-2 px-4 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 disabled:opacity-50 disabled:cursor-not-allowed"
              >
                {processing ? 'Creating Team...' : 'Create Team'}
              </button>
            </div>
          </form>
        </div>
      </div>
    </div>
  );
}
