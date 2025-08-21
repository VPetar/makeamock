import { useForm, usePage } from "@inertiajs/react";
import { Alert, AlertDescription, AlertTitle } from "@/components/ui/alert.tsx";
import { AlertCircleIcon, CheckCircle2Icon, PopcornIcon } from "lucide-react";
import {
  Disclosure,
  DisclosureButton,
  DisclosurePanel,
  Menu,
  MenuButton,
  MenuItem,
  MenuItems,
} from "@headlessui/react";
import { Bars3Icon, BellIcon, XMarkIcon } from "@heroicons/react/24/outline";
import {
  dashboard_home_index_path,
  destroy_user_session_path,
  new_user_registration_path,
  new_user_session_path,
} from "@/routes";
import { Button } from "@/components/ui/button.tsx";

export default function PublicLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  const sharedProps = usePage<{
    has_flash: boolean;
    flash: Record<string, string>;
    has_user: boolean;
    user: { name: string; email: string };
  }>().props;

  const flashType =
    sharedProps.has_flash ?
      Object.keys(sharedProps.flash).filter((key) =>
        ["error", "success", "info", "alert", "notice"].includes(key),
      )[0] || "info"
    : "info";

  const iconLookup: Record<string, React.ReactNode> = {
    success: <CheckCircle2Icon />,
    error: <AlertCircleIcon />,
    info: <PopcornIcon />,
    alert: <AlertCircleIcon />,
    notice: <PopcornIcon />,
  };

  const {delete: deleteRequest} = useForm()

  function logout() {
    deleteRequest(destroy_user_session_path())
  }

  return (
    <>
      <Disclosure as="nav" className="relative bg-white shadow-sm">
        <div className="mx-auto max-w-7xl px-2 sm:px-6 lg:px-8">
          <div className="relative flex h-16 justify-between">
            <div className="absolute inset-y-0 left-0 flex items-center sm:hidden">
              {/* Mobile menu button */}
              <DisclosureButton className="group relative inline-flex items-center justify-center rounded-md p-2 text-gray-400 hover:bg-gray-100 hover:text-gray-500 focus:ring-2 focus:ring-indigo-600 focus:outline-hidden focus:ring-inset">
                <span className="absolute -inset-0.5" />
                <span className="sr-only">Open main menu</span>
                <Bars3Icon
                  aria-hidden="true"
                  className="block size-6 group-data-open:hidden"
                />
                <XMarkIcon
                  aria-hidden="true"
                  className="hidden size-6 group-data-open:block"
                />
              </DisclosureButton>
            </div>
            <div className="flex flex-1 items-center justify-center sm:items-stretch sm:justify-start">
              <div className="flex shrink-0 items-center">
                <img
                  alt="Your Company"
                  src="https://tailwindcss.com/plus-assets/img/logos/mark.svg?color=indigo&shade=600"
                  className="h-8 w-auto"
                />
              </div>
              <div className="hidden sm:ml-6 sm:flex sm:space-x-8">
                {/* Current: "border-indigo-600 text-gray-900", Default: "border-transparent text-gray-500 hover:border-gray-300 hover:text-gray-700" */}
                <a
                  href="#"
                  className="inline-flex items-center border-b-2 border-indigo-600 px-1 pt-1 text-sm font-medium text-gray-900"
                >
                  Dashboard
                </a>
                <a
                  href="#"
                  className="inline-flex items-center border-b-2 border-transparent px-1 pt-1 text-sm font-medium text-gray-500 hover:border-gray-300 hover:text-gray-700"
                >
                  Team
                </a>
                <a
                  href="#"
                  className="inline-flex items-center border-b-2 border-transparent px-1 pt-1 text-sm font-medium text-gray-500 hover:border-gray-300 hover:text-gray-700"
                >
                  Projects
                </a>
                <a
                  href="#"
                  className="inline-flex items-center border-b-2 border-transparent px-1 pt-1 text-sm font-medium text-gray-500 hover:border-gray-300 hover:text-gray-700"
                >
                  Calendar
                </a>
              </div>
            </div>
            {sharedProps.has_user ?
              <div className="absolute inset-y-0 right-0 flex items-center pr-2 sm:static sm:inset-auto sm:ml-6 sm:pr-0">
                {/* Profile dropdown */}
                <Menu as="div" className="relative ml-3">
                  <MenuButton className="relative flex rounded-full focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600">
                    <span className="absolute -inset-1.5" />
                    <span className="sr-only">Open user menu</span>
                    <img
                      alt=""
                      // src={`https://avatars.laravel.cloud/${sharedProps.user.email}&vibe=ice`}
                      src={`https://robohash.org/${sharedProps.user.email}.png`}
                      className="size-8 rounded-full bg-gray-100 outline -outline-offset-1 outline-black/5"
                    />
                  </MenuButton>

                  <MenuItems
                    transition
                    className="absolute right-0 z-10 mt-2 w-48 origin-top-right rounded-md bg-white py-1 shadow-lg outline outline-black/5 transition data-closed:scale-95 data-closed:transform data-closed:opacity-0 data-enter:duration-200 data-enter:ease-out data-leave:duration-75 data-leave:ease-in"
                  >
                    <MenuItem>
                      <a
                        href={dashboard_home_index_path()}
                        className="block px-4 py-2 text-sm text-gray-700 data-focus:bg-gray-100 data-focus:outline-hidden"
                      >
                        Dashboard
                      </a>
                    </MenuItem>
                    <MenuItem>
                      <a
                        href="#"
                        onClick={logout}
                        className="block px-4 py-2 text-sm text-gray-700 data-focus:bg-gray-100 data-focus:outline-hidden"
                      >
                        Sign out
                      </a>
                    </MenuItem>
                  </MenuItems>
                </Menu>
              </div>
            : <div className="absolute inset-y-0 right-0 flex items-center pr-2 sm:static sm:inset-auto sm:ml-6 sm:pr-0 gap-2">
                <Button variant="default" asChild>
                  <a href={new_user_session_path()}>Login</a>
                </Button>
                <Button asChild variant="outline">
                  <a href={new_user_registration_path()}>Sign up</a>
                </Button>
              </div>
            }
          </div>
        </div>

        <DisclosurePanel className="sm:hidden">
          <div className="space-y-1 pt-2 pb-4">
            {/* Current: "bg-indigo-50 border-indigo-600 text-indigo-700", Default: "border-transparent text-gray-500 hover:border-gray-300 hover:bg-gray-50 hover:text-gray-700" */}
            <DisclosureButton
              as="a"
              href="#"
              className="block border-l-4 border-indigo-600 bg-indigo-50 py-2 pr-4 pl-3 text-base font-medium text-indigo-700"
            >
              Dashboard
            </DisclosureButton>
            <DisclosureButton
              as="a"
              href="#"
              className="block border-l-4 border-transparent py-2 pr-4 pl-3 text-base font-medium text-gray-500 hover:border-gray-300 hover:bg-gray-50 hover:text-gray-700"
            >
              Team
            </DisclosureButton>
            <DisclosureButton
              as="a"
              href="#"
              className="block border-l-4 border-transparent py-2 pr-4 pl-3 text-base font-medium text-gray-500 hover:border-gray-300 hover:bg-gray-50 hover:text-gray-700"
            >
              Projects
            </DisclosureButton>
            <DisclosureButton
              as="a"
              href="#"
              className="block border-l-4 border-transparent py-2 pr-4 pl-3 text-base font-medium text-gray-500 hover:border-gray-300 hover:bg-gray-50 hover:text-gray-700"
            >
              Calendar
            </DisclosureButton>
          </div>
        </DisclosurePanel>
      </Disclosure>
      <div className="flex justify-center items-center">
        <div className="grid w-full max-w-xl items-start gap-4 py-2">
          {sharedProps.has_flash ?
            <Alert>
              {iconLookup[flashType] ?? <PopcornIcon />}
              <AlertTitle className="capitalize">{flashType}</AlertTitle>
              <AlertDescription>
                {sharedProps.flash[flashType]}
              </AlertDescription>
            </Alert>
          : null}
        </div>
      </div>
      {children}
    </>
  );
}
