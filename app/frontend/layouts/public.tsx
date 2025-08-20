import { usePage } from "@inertiajs/react";
import { Alert, AlertDescription, AlertTitle } from "@/components/ui/alert.tsx";
import { AlertCircleIcon, CheckCircle2Icon, PopcornIcon } from "lucide-react";

export default function PublicLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  const sharedProps = usePage<{
    has_flash: boolean;
    flash: Record<string, string>;
  }>().props;

  console.log("sharedProps", sharedProps);

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

  return (
    <>
      <div className="flex justify-center items-center">
        <div className="grid w-full max-w-xl items-start gap-4">
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
